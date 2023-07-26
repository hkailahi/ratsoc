module Types where

import Relude
import Data.Time.Clock.Compat

---------------------------------------------------------------------------------------------------
-- Core Types
---------------------------------------------------------------------------------------------------

data Book = Book
  { bookTitle :: BookTitle,
    bookAuthor :: Author,
    bookIsbn :: ISBN, -- International Standard Book Number

    -- | only false when checked out, default to true
    availability :: Availability -- status (whether the book is currently available for borrowing or not)
    -- TODO Multiple copies of each book?? Should availability really be an attribute of book?
  }
  deriving stock (Eq, Show, Generic)
  deriving anyclass (Hashable)

data Patron = Patron
  { name :: PatronName,
    cardNumber :: CardNumber, -- Globablly unique library card number (across all branches)
    borrowedList :: [Book] -- List of borrowed books
    -- TODO Multiple copies of each book?? Should availability really be an attribute of book?
  }
  deriving stock (Eq, Show, Generic)
  deriving anyclass (Hashable)

---------------------------------------------------------------------------------------------------
-- Field Wrappers
---------------------------------------------------------------------------------------------------

newtype BookTitle = BookTitle
  { unBookTitle :: Text }
  deriving stock (Eq, Show, Generic)
  deriving anyclass (Hashable)

newtype Author = Author
  {unAuthor :: Text}
  deriving stock (Eq, Show, Generic)
  deriving anyclass (Hashable)

newtype ISBN = ISBN
  {unISBN :: Text}
  deriving stock (Eq, Show, Generic)
  deriving anyclass (Hashable)

data Availability =
    Available
  | DueBy UTCTime
  deriving stock (Eq, Show, Generic)
  deriving anyclass (Hashable)

newtype PatronName = PatronName
  { unPatronName :: Text }
  deriving stock (Eq, Show, Generic)
  deriving anyclass (Hashable)

-- Invariant: Unique across all library branches
newtype CardNumber = CardNumber
  { unCardNumber :: Int }
  deriving stock (Eq, Show, Generic)
  deriving anyclass (Hashable)

