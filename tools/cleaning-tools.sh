#!/bin/sh

error() {
    echo "Error: $1" >&2
    exit 1
}

clean_tutorial() {
    (
        set -e -u
        cd "$1"
        echo "-- Cleaning up all cases in $(pwd)..."
        rm -rfv ./precice-run/

        for case in */; do
            if [ "${case}" = images/ ]; then
                continue
            fi
            (cd "${case}" && ./clean.sh || echo "No cleaning script in ${case} - skipping")
        done
    )
}

clean_precice_logs() {
    (
        set -e -u
        cd "$1"
        echo "---- Cleaning up preCICE logs in $(pwd)"
        rm -fv ./precice-*-iterations.log \
            ./precice-*-convergence.log \
            ./precice-*-watchpoint-*.log \
            ./precice-*-watchintegral-*.log \
            ./events.json \
            ./core
        rm -rfv ./precice-events/
    )
}

clean_calculix() {
    (
        set -e -u
        cd "$1"
        echo "--- Cleaning up CalculiX case in $(pwd)"
        rm -fv ./*.cvg ./*.dat ./*.frd ./*.sta ./*.12d spooles.out dummy
        rm -fv WarnNodeMissMultiStage.nam
        rm -fv ./*.eig
        clean_precice_logs .
    )
}

clean_codeaster() {
    (
        set -e -u
        cd "$1"
        echo "--- Cleaning up code_aster case in $(pwd)"
        rm -fv ./*.mess ./*.resu ./*.rmed
        rm -rfv ./REPE_OUT/*
        clean_precice_logs .
    )
}

clean_dealii() {
    (
        set -e -u
        cd "$1"
        echo "--- Cleaning up deal.II case in $(pwd)"
        rm -rfv ./dealii-output/
        clean_precice_logs .
    )
}

clean_fenics() {
    (
        set -e -u
        cd "$1"
        echo "--- Cleaning up FEniCS case in $(pwd)"
        rm -rfv ./output/
        rm -rfv ./preCICE-output/
        clean_precice_logs .
    )
}

clean_nutils() {
    (
        set -e -u
        cd "$1"
        echo "--- Cleaning up Nutils case in $(pwd)"
        rm -fv ./*.vtk
        rm -rfv ./preCICE-output/
        clean_precice_logs .
    )
}

clean_openfoam() {
    (
        set -e -u
        cd "$1"
        echo "--- Cleaning up OpenFOAM case in $(pwd)"
        if [ -n "${WM_PROJECT:-}" ] || error "No OpenFOAM environment is active."; then
            # shellcheck disable=SC1090 # This is an OpenFOAM file which we don't need to check
            . "${WM_PROJECT_DIR}/bin/tools/CleanFunctions"
            cleanCase
            rm -rfv 0/uniform/functionObjects/functionObjectProperties history
        fi
        rm -rfv ./preCICE-output/
        clean_precice_logs .
    )
}

clean_su2() {
    (
        set -e -u
        cd "$1"
        echo "--- Cleaning up SU2 case in $(pwd)"
        rm -fv ./restart_flow_*.dat forces_breakdown.dat ./surface_flow_*.csv ./flow_*.vtk ./history_*.vtk
        clean_precice_logs .
    )
}

clean_aste() {
    (
        set -e -u
        echo "--- Cleaning up ASTE results"
        rm -fv result.vtk result.stats.json
        rm -fvr fine_mesh coarse_mesh mapped
    )
}

clean_dune() {
    (
        set -e -u
        cd "$1"
        echo "--- Cleaning up DUNE case in $(pwd)"
        rm -fv ./dgfparser.log
        rm -fv ./*.pvd
        rm -fv ./*.vtu
        rm -rfv ./preCICE-output/
        rm -rfv ./output/
        clean_precice_logs .
    )
}

clean_abaqus() {
    (
        set -e -u
	    cd "$1"
	    echo "--- Cleaning up ABAQUS case in $(pwd)"
        rm -rfv ./*.abq
        rm -rfv ./*.com
        rm -rfv ./*.dat
        rm -rfv ./*mdl
        rm -rfv ./*.msg
        rm -rfv ./*.odb
        rm -rfv ./*.pac
        rm -rfv ./*.prt
        rm -rfv ./*.res
        rm -rfv ./*.sel
        rm -rfv ./*.sta
        rm -rfv ./*.stt
        rm -rfv ./*.src
        rm -rfv ./*.exception
        rm -rfv ./*.cid
        rm -rfv ./*.lck
        rm -rfv ./*.env
        rm -rfv ./*.simlog
        rm -rfv ./*.simdir
        rm -fv ./*.bak
        rm -fv ./*.rpy
        rm -fv ./*.par
        rm -fv ./*.pes
        rm -fv ./*.pmg
        rm -fv ./*.sim
        clean_precice_logs .
    )
}
