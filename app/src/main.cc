#include <zephyr/drivers/gpio.h>

#include "pw_assert/check.h"
#include "pw_chrono/system_clock.h"
#include "pw_digital_io_zephyr/digital_io.h"
#include "pw_log/log.h"
#include "pw_thread/sleep.h"

using namespace std::chrono_literals;

namespace {

constexpr auto kBlinkInterval = 1s;

}  // namespace

int main() {
  pw::digital_io::ZephyrDigitalOut led(GPIO_DT_SPEC_GET(DT_ALIAS(led0), gpios));
  PW_CHECK_OK(led.Enable());

  bool led_on = false;
  while (true) {
    led_on = !led_on;
    PW_CHECK_OK(led.SetState(led_on ? pw::digital_io::State::kActive
                                    : pw::digital_io::State::kInactive));
    PW_LOG_INFO("LED state: %s", led_on ? "ON" : "OFF");
    pw::this_thread::sleep_for(
        pw::chrono::SystemClock::for_at_least(kBlinkInterval));
  }
}
