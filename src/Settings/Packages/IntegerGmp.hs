module Settings.Packages.IntegerGmp (integerGmpPackageArgs, gmpBuildPath) where

import Base
import Expression
import GHC (integerGmp)
import Predicates (builder, builderGcc, package)
import Settings.Paths
import Oracles.Config.Setting

-- TODO: move build artefacts to buildRootPath, see #113
-- TODO: Is this needed?
-- ifeq "$(GMP_PREFER_FRAMEWORK)" "YES"
-- libraries/integer-gmp_CONFIGURE_OPTS += --with-gmp-framework-preferred
-- endif
integerGmpPackageArgs :: Args
integerGmpPackageArgs = package integerGmp ? do
    let includeGmp = "-I" ++ gmpBuildPath -/- "include"
    gmp_includedir <- getSetting GmpIncludeDir
    gmp_libdir <- getSetting GmpLibDir
    let gmp_args = if (gmp_includedir == "" && gmp_libdir == "")
                   then
                   [ arg "--configure-option=--with-intree-gmp" ]
                   else
                   []

    mconcat [ builder GhcCabal ? mconcat
              (gmp_args ++
               [ appendSub "--configure-option=CFLAGS" [includeGmp]
               , appendSub "--gcc-options"             [includeGmp] ] )

            , builderGcc ? arg includeGmp ]
