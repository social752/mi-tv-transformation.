# shellcheck shell=bash
# Expected device identity. The scripts refuse to run if the connected TV does not match.
# Values come from the TV's About screen. After running 00-verify-device.sh the first time,
# compare the printed ro.product.model with the TV: Xiaomi codes often contain the
# LETTER "O" (e.g. MITV-AXSO0) where a zero might be read. Only edit after confirming.

EXPECTED_MODEL="MITV-AXS00"
EXPECTED_ANDROID_RELEASE="9"
EXPECTED_SDK="28"
EXPECTED_BUILD_TOKEN="PI.6681"
