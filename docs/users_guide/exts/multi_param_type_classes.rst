.. _multi-param-type-classes:

Multi-parameter type classes
============================

.. extension:: MultiParamTypeClasses
    :shortdesc: Enable multi parameter type classes.
         Implied by :extension:`FunctionalDependencies`.
         Implies :extension:`ConstrainedClassMethods`.

    :implies: :extension:`ConstrainedClassMethods`
    :implied by: :extension:`FunctionalDependencies`
    :since: 6.8.1

    :status: Included in :extension:`GHC2021`

    Allow the definition of typeclasses with more than one parameter.

Multi-parameter type classes are permitted, with extension
:extension:`MultiParamTypeClasses`. For example: ::

      class Collection c a where
          union :: c a -> c a -> c a
          ...etc.
