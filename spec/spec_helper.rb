require 'rubygems'
require 'bundler/setup'

require 'awesome_print'

require 'x12'

RSpec.configure do |config|
  # some (optional) config here
end

def sample_xml
<<EOF
<Loop name="outer" comment="a comment">
<Segment name="ST" required="y" max="1">
  <Field name="field1" const="270" comment="field"/>
  <Field name="field2" min="4" max="9" comment="field"/>
</Segment>
<Segment name="BHT" required="y" max="1" comment="comment">
  <Field name="field1" required="y" const="0022"                       comment="field"/>
  <Field name="field2" required="y" min="2" max="2"  validation="T353" comment="field"/>
</Segment>
</Loop>
EOF
end
