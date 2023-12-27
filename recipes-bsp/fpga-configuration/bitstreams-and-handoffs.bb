SUMMARY = "rbf deploy recipe"
DESCRIPTION = ""
SECTION = "bsp"

LICENSE = "CLOSED"

inherit deploy

A10S_CORE_RBF = "mitysom_a10s.core.rbf"
A10S_PERIPH_RBF = "mitysom_a10s.periph.rbf"
A10S_HPS = "hps.xml"

SRC_A10S_CORE_RBF ?= "${A10S_CORE_RBF}"
SRC_A10S_PERIPH_RBF ?= "${A10S_PERIPH_RBF}"
SRC_A10S_HPS ?= "${A10S_HPS}"

SRC_URI:mitysoma10s ?= "\
    file://${SRC_A10S_CORE_RBF} \
    file://${SRC_A10S_PERIPH_RBF} \
    file://${SRC_A10S_HPS} \
    "


do_deploy() {
    if ${@bb.utils.contains("MACHINE", "mitysoma10s", "true", "false", d)}; then
        install -D -m 0644 ${WORKDIR}/${SRC_A10S_CORE_RBF} ${DEPLOYDIR}/${A10S_CORE_RBF}
        install -D -m 0644 ${WORKDIR}/${SRC_A10S_PERIPH_RBF} ${DEPLOYDIR}/${A10S_PERIPH_RBF}
        install -D -m 0644 ${WORKDIR}/${SRC_A10S_HPS} ${DEPLOYDIR}/${A10S_HPS}
    fi
}

addtask deploy after do_install