module Library where

import Relude
import Data.HashMap.Strict as HM

import Types
import Data.Time.Clock.Compat

-- TODO: Track # of available copies
-- Pre-condition: Finite number of books
data Library = Library
  { booksByPatron :: HashMap CardNumber Book
  ,  availableBooks :: HashMap Book Int -- Book : # of available copies, every book should be available
    -- , borrowedBooks :: HashMap Book [Patron]
  }
  deriving (Eq, Show)

emptyLibrary :: Library
emptyLibrary = Library HM.empty HM.empty

-- Branches are an ordered collection of libaries with `HashMap.union` operations over internal maps
emptyBranchList :: [Library]
emptyBranchList = []

-- Adding new books to the library.
-- - Removing books from the library.
-- - Searching for books by title, author, or ISBN.
-- - Displaying the availability of a specific book.
-- - Allowing patrons to borrow books.
-- - Tracking borrowed books and their due dates.
-- - Allowing patrons to return books.

---------------------------------------------------------------------------------------------------
-- General Utilites
---------------------------------------------------------------------------------------------------

getDueDate :: Book -> Maybe UTCTime
getDueDate book =
  case availability book of
    Available -> Nothing
    DueBy dueTime -> Just dueTime

---------------------------------------------------------------------------------------------------
-- Librarian Activities
---------------------------------------------------------------------------------------------------

addBook :: Library -> Book -> Library
addBook (Library borrowed available) book =
  Library borrowed $ HM.alter incrementBookCount book available
    where
      incrementBookCount :: Maybe Int -> Maybe Int
      incrementBookCount = \case
        Nothing -> Just 1
        Just count -> Just $ count + 1

-- TODO: Pre-condition: Can't remove books that are currently checked out = no-op
-- TODO: Remove all copies or just one??
removeBook :: Library -> Book -> Library
removeBook (Library borrowed available) book =
  Library borrowed $ HM.alter incrementBookCount book available
    where
      incrementBookCount :: Maybe Int -> Maybe Int
      incrementBookCount = \case
        Nothing -> Just 0
        Just count -> Just $ count - 1

---------------------------------------------------------------------------------------------------
-- Search (From Available)
---------------------------------------------------------------------------------------------------

-- TODO Union with currently-checked out books
-- TODO Factor out duplication

findBookByTitle :: Library -> BookTitle -> [Book]
findBookByTitle lib title =
   HM.keys . HM.filterWithKey isMatchingTitle $ availableBooks lib
    where
      isMatchingTitle :: Book -> Bool
      isMatchingTitle book = title == bookTitle book

findBookByAuthor :: Library -> Author -> [Book]
findBookByTitle lib author =
  HM.keys . HM.filterWithKey isMatchingAuthor $ availableBooks lib
    where
      isMatchingAuthor :: Book -> Bool
      isMatchingAuthor book = title == bookAuthor book

findBookByISBN :: Library -> ISBN -> Book
findBookByISBN lib isbn =
  HM.keys . HM.filterWithKey isMatchingISBN $ availableBooks lib
    where
      isMatchingISBN :: Book -> Bool
      isMatchingISBN book = isbn == bookISBN book

---------------------------------------------------------------------------------------------------
-- Patron Activities
---------------------------------------------------------------------------------------------------

-- borrowBook :: Library -> BookTitle -> Patron -> Library
-- borrowBook lib title patron =
--   case HM.lookup $ availableBooks lib of
--     Nothing ->
--     Just book ->
--   -- findBookByTitle
--   -- findBookByAuthor
--   -- findBookByISBN

-- returnBook :: Library -> Patron -> Book -> Library
-- returnBook =

---------------------------------------------------------------------------------------------------
-- Librarian Book-Keeping Operations
---------------------------------------------------------------------------------------------------

getDueDates :: Library -> [(Book, Maybe UTCTime)]
getDueDates lib =
  fmap (\book -> (book, getDueDate book)) (HM.elems $ booksByPatron lib :: [Book])

getOverdueBooks :: UTCTime -> Library -> [Book]
getOverdueBooks currTime lib =
  HM.elems . HM.filter isOverDue $ booksByPatron lib
    where
      isOverDue :: Book -> Bool
      isOverDue book =
        case availability book of
          Available -> False
          DueBy dueTime -> currTime >= dueTime
