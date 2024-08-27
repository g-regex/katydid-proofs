-- A translation to Lean from Agda
-- https://github.com/conal/paper-2021-language-derivatives/blob/main/Symbolic.lagda

import Katydid.Conal.Decidability
import Katydid.Conal.Function
import Katydid.Conal.Language
import Katydid.Conal.Calculus

namespace Symbolic

-- data Lang : ◇.Lang → Set (suc ℓ) where
inductive Lang: Language.Lang.{u} α -> Type (u + 1) where
  -- ∅ : Lang ◇.∅
  | emptyset : Lang Language.emptyset
  -- 𝒰 : Lang ◇.𝒰
  | universal : Lang Language.universal
  -- 𝟏 : Lang ◇.𝟏
  | emptystr : Lang Language.emptystr
  -- ` : (a : A) → Lang (◇.` a)
  | char {a: Type u}: (a: α) -> Lang (Language.char a)
  -- _∪_ : Lang P → Lang Q → Lang (P ◇.∪ Q)
  | or : Lang P -> Lang Q -> Lang (Language.or P Q)
  -- _∩_ : Lang P → Lang Q → Lang (P ◇.∩ Q)
  | and : Lang P -> Lang Q -> Lang (Language.and P Q)
  -- _·_ : Dec s → Lang P → Lang (s ◇.· P)
  | scalar {s: Type u}: (Decidability.Dec s) -> Lang P -> Lang (Language.scalar s P)
  -- _⋆_ : Lang  P → Lang Q → Lang (P ◇.⋆ Q)
  | concat : Lang P -> Lang Q -> Lang (Language.concat P Q)
  -- _☆  : Lang P → Lang (P ◇.☆)
  | star : Lang P -> Lang (Language.star P)
  -- TODO: complete definition of Lang by adding the last operator:
  -- _◂_  : (Q ⟷ P) → Lang P → Lang Q
  -- We tried this definition in Lean:
  -- | iso {P Q: Language.Lang α}: (Q ⟷ P) -> Lang P -> Lang Q
  -- But we got the following error:
  -- "(kernel) declaration has free variables 'Symbolic.Lang.iso'"
  -- The paper says: "The reason _◀_ must be part of the inductive representation is the same as the other constructors, namely so that the core lemmas (Figure 3) translate into an implementation in terms of that representation."

-- ν  : Lang P → Dec (◇.ν P)
def null (l: Lang P): Decidability.Dec (Calculus.null P) :=
  match l with
  -- ν ∅ = ⊥‽
  | Lang.emptyset => Decidability.empty?
  -- ν 𝒰 = ⊤‽
  | Lang.universal => Decidability.unit?
  -- ν 𝟏 = ν𝟏 ◃ ⊤‽
  | Lang.emptystr => Decidability.apply' Calculus.null_emptystr Decidability.unit?
  -- ν (p ∪ q) = ν p ⊎‽ ν q
  | Lang.or p q => Decidability.sum? (null p) (null q)
  -- ν (p ∩ q) = ν p ×‽ ν q
  | Lang.and p q => Decidability.prod? (null p) (null q)
  -- ν (s · p) = s ×‽ ν p
  | Lang.scalar s p => Decidability.prod? s (null p)
  -- ν (p ⋆ q) = ν⋆ ◃ (ν p ×‽ ν q)
  | Lang.concat p q => Decidability.apply' Calculus.null_concat (Decidability.prod? (null p) (null q))
  -- ν (p ☆) = ν☆ ◃ (ν p ✶‽)
  | Lang.star p => Decidability.apply' Calculus.null_star (Decidability.list? (null p))
  -- ν (` a) = ν` ◃ ⊥‽
  | Lang.char a => Decidability.apply' Calculus.null_char Decidability.empty?
  -- TODO: Add the case for language iso morphism, once the Lang.iso operator is added:
  -- ν (f ◂ p) = f ◃ ν p
  -- | Lang.iso f p => Decidability.apply' f (null p)

-- δ  : Lang P → (a : A) → Lang (◇.δ P a)
-- def derive (l: @Lang α P) (a: α): Lang (Calculus.derive P a) :=
--   match l with
--   -- δ ∅ a = ∅
--   | Lang.emptyset => Lang.emptyset
--   -- δ 𝒰 a = 𝒰
--   | Lang.universal => Lang.universal
--   -- δ (p ∪ q) a = δ p a ∪ δ q a
--   | Lang.or p q => Lang.or (derive p a) (derive q a)
--   -- δ (p ∩ q) a = δ p a ∩ δ q a
--   | Lang.and p q => Lang.and (derive p a) (derive q a)
--   -- δ (s · p) a = s · δ p a
--   | Lang.scalar s p => Lang.scalar s (derive p a)
--   -- δ 𝟏 a = δ𝟏 ◂ ∅
--   | Lang.emptystr => (Lang.iso Calculus.derive_emptystr Lang.emptyset)
--   -- δ (p ⋆ q) a = δ⋆ ◂ (ν p · δ q a ∪ δ p a ⋆ q)
--   | Lang.concat p q =>
--     (Lang.iso Calculus.derive_concat
--       (Lang.scalar (null p)
--         (Lang.or
--           (derive q a)
--           (Lang.concat (derive p a) q)
--         )
--       )
--     )
--   -- δ (p ☆) a = δ☆ ◂ (ν p ✶‽ · (δ p a ⋆ p ☆))
--   | Lang.star p =>
--     (Lang.iso Calculus.derive_star
--       (Lang.scalar
--         (Decidability.list? (null p))
--         (Lang.concat (derive p a) (Lang.star p))
--       )
--     )
--   -- δ (` c) a = δ` ◂ ((a ≟ c) · 𝟏)
--   | Lang.char c =>
--     (Lang.iso Calculus.derive_char
--       -- TODO: not sure if ≟ is the same as ≡
--       (Lang.scalar (a ≡ c) Lang.emptystr)
--     )
  -- TODO: Add the case for language iso morphism, once the Lang.iso operator is added:
  -- δ (f ◂ p) a = f ◂ δ p a
  -- | Lang.iso f p => Lang.iso f (derive p a)

end Symbolic
