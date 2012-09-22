#--
#     This file is part of the X12Parser library that provides tools to
#     manipulate X12 messages using Ruby native syntax.
#
#     http://x12parser.rubyforge.org 
#     
#     Copyright (C) 2008 APP Design, Inc.
#
#     This library is free software; you can redistribute it and/or
#     modify it under the terms of the GNU Lesser General Public
#     License as published by the Free Software Foundation; either
#     version 2.1 of the License, or (at your option) any later version.
#
#     This library is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#     Lesser General Public License for more details.
#
#     You should have received a copy of the GNU Lesser General Public
#     License along with this library; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#++
#
module X12

  # $Id: Loop.rb 59 2009-03-19 22:32:13Z ikk $
  #
  # Implements nested loops of segments

  class Loop < Base

#     def regexp
#       @regexp ||= 
#         Regexp.new(inject(''){|s, i|
#                      puts i.class
#                      s += case i
#                           when X12::Segment: "(#{i.regexp.source}){#{i.repeats.begin},#{i.repeats.end}}"
#                           when X12::Loop:    "(.*?)"
#                           else
#                             ''
#                           end
#                    })
#     end

    # Parse a string and fill out internal structures with the pieces of it. Returns 
    # an unparsed portion of the string or the original string if nothing was parsed out.
    def parse(document)
      #puts "Parsing loop #{name}: " + document
      working = document

      all_matched = true
      nodes.each do |node|
        matched = node.parse(working)
        if matched
          working = matched
        else
          all_matched = false unless node.repeats.begin == 0
        end
        working = matched if matched
      end

      return nil if document == working
      return document if all_matched == false

      self.parsed_str = document[0..-working.length-1]
      working = do_repeats(working)
    end # parse

    def do_repeats(document)
      if self.repeats.end > 1
        possible_repeat = self.dup
        p_s = possible_repeat.parse(document)
        if p_s && p_s != document
          document = p_s
          self.next_repeat = possible_repeat
        end # if parsed
      end # more repeats
      document
    end # do_repeats

    # Render all components of this loop as string suitable for EDI
    def render
      if self.has_content?
        self.to_a.inject(''){|loop_str, i|
          loop_str += i.nodes.inject(''){|nodes_str, j|
            nodes_str += j.render
          } 
        }
      else
        ''
      end
    end # render

  end # Loop
end # X12
