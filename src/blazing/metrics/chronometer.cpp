#include "chronometer.hpp"

#include <chrono>

namespace blazing {
namespace metrics {

// Check

void Check::State(bool expressionValue) {
    if (!expressionValue) { throw IllegalStateException(); }
}

// Watch

namespace {

class BLAZING_NOEXPORT InternalWatchBase : public Watch {
    BLAZING_CONCRETE(InternalWatchBase);

public:
    explicit InternalWatchBase() = default;

    std::uintmax_t Read() const noexcept final {
        return static_cast<std::uintmax_t>(
            std::chrono::time_point_cast<std::chrono::nanoseconds>(
                std::chrono::system_clock::now())
                .time_since_epoch()
                .count());
    }
};

}  // namespace

std::unique_ptr<Watch> Watch::InternalWatch() noexcept {
    return std::make_unique<InternalWatchBase>();
}

// Chronometer

namespace {

class BLAZING_NOEXPORT ChronometerBase : public Chronometer {
    BLAZING_CONCRETE(ChronometerBase);

public:
    explicit ChronometerBase(const Watch & watch) : watch_{watch} {}

    bool IsRunning() const noexcept final { return isRunning_; }

    Chronometer & Start() final {
        Check::State(!isRunning_);
        isRunning_ = true;
        startTime_ = watch_.Read();
        return *this;
    }

    Chronometer & Stop() final {
        const std::uintmax_t stopTime = watch_.Read();
        Check::State(isRunning_);
        isRunning_ = false;
        elapsedTime_ += stopTime - startTime_;
        return *this;
    }

    std::uintmax_t Elapsed() const noexcept {
        return isRunning_ ? watch_.Read() - startTime_ + elapsedTime_
                          : elapsedTime_;
    }

    std::uintmax_t BLAZING_NORETURN
                   Elapsed(const TimeUnit::type /*timeUnitType*/) const noexcept {
        BLAZING_ABORT("Not Implemented");
        // TODO: return timeUnit.convertFrom(Elapsed(), NANOSECOND);
    }

    Chronometer & Reset() noexcept final {
        isRunning_   = false;
        elapsedTime_ = 0;
        return *this;
    }

private:
    const Watch &  watch_;
    bool           isRunning_;
    std::uintmax_t startTime_;
    std::uintmax_t elapsedTime_;
};

class BLAZING_NOEXPORT WithManagedWatch {
    BLAZING_CONCRETE(WithManagedWatch);

public:
    explicit WithManagedWatch() : watch_{Watch::InternalWatch()} {}

    const Watch & watch() const noexcept { return *watch_; }

private:
    const std::unique_ptr<const Watch> watch_;
};

class BLAZING_NOEXPORT ChronometerContent : public ChronometerBase {
    BLAZING_CONCRETE(ChronometerContent);

public:
    explicit ChronometerContent(const Watch & watch) : ChronometerBase{watch} {
        Reset();
    }
};

class BLAZING_NOEXPORT UnstartedChronometer : public WithManagedWatch,
                                              public ChronometerBase {
    BLAZING_CONCRETE(UnstartedChronometer);

public:
    explicit UnstartedChronometer() : ChronometerBase{watch()} { Reset(); }
};

class BLAZING_NOEXPORT StartedChronometer : public UnstartedChronometer {
    BLAZING_CONCRETE(StartedChronometer);

public:
    explicit StartedChronometer() { Start(); }
};

}  // namespace

std::unique_ptr<Chronometer> Chronometer::MakeUnstarted() {
    return std::make_unique<UnstartedChronometer>();
}

std::unique_ptr<Chronometer> Chronometer::MakeStarted() {
    return std::make_unique<StartedChronometer>();
}

std::unique_ptr<Chronometer> Chronometer::Content(const Watch & watch) {
    return std::make_unique<ChronometerContent>(watch);
}

}  // namespace metrics
}  // namespace blazing