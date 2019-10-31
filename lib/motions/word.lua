local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")
local Set = dofile(vimModeScriptPath .. "lib/utils/set.lua")

local Word = Motion:new()

-- word motion, exclusive
--
-- from :help motions.txt
--
-- <S-Right>	or					*<S-Right>* *w*
-- w			[count] words forward.  |exclusive| motion.
--
--

local punctuation = Set{
  "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "=", "+", "[", "{",
  "}", "]", "|", " '", "\"", ":", ";", ",", ".", "/", "?", "`"
}

function isPunctuation(char)
  return not not punctuation[char]
end

-- TODO handle more edge cases for :help word
function Word:getRange(buffer)
  local start = buffer.selection:positionEnd()

  local range = {
    start = start,
    mode = 'exclusive',
    direction = 'characterwise'
  }

  range.finish = start

  local seenWhitespace = false

  while range.finish < buffer:getLength() do
    local charIndex = range.finish + 1 -- lua strings are 1-indexed :(
    local char = string.sub(buffer.contents, charIndex, charIndex)

    range.finish = range.finish + 1

    if seenWhitespace and char ~= " " then break end
    if isPunctuation(char) then break end

    if not seenWhitespace and char == " " then
      seenWhitespace = true
    end
  end

  return range
end

function Word.getMovements()
  return {
    {
      modifiers = { 'alt' },
      character = 'right'
    }
  }
end

return Word
