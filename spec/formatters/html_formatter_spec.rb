require 'spec_helper'

describe Ruport::Formatter::HTML do
  it "should escape the HTML" do
    actual = Ruport::Controller::Table.render_html { |r|
      r.data = Table([], :data => [["1"," ","&"],["<script>",5,6]])
    }          
    
    actual.should == "\t<table>\n\t\t<tr>\n\t\t\t<td>1</td>\n\t\t\t<td> "+
                 "</td>\n\t\t\t<td>&amp;</td>\n\t\t</tr>\n\t\t<tr>\n\t\t"+
                 "\t<td>&lt;script&gt;</td>\n\t\t\t<td>5</td>\n\t\t\t<td>6</td>\n\t"+
                 "\t</tr>\n\t</table>\n"

    actual = Ruport::Controller::Table.render_html { |r| 
      r.data = Table(%w[a b c], :data => [["1"," ","&"],["<script>",5,6]])
    }
    
    actual.should == "\t<table>\n\t\t<tr>\n\t\t\t<th>a</th>\n\t\t\t<th>b</th>"+
                "\n\t\t\t<th>c</th>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>1</td>\n\t\t\t<td> "+
                "</td>\n\t\t\t<td>&amp;</td>\n\t\t</tr>\n\t\t<tr>\n\t\t"+
                "\t<td>&lt;script&gt;</td>\n\t\t\t<td>5</td>\n\t\t\t<td>6</td>\n\t"+
                "\t</tr>\n\t</table>\n"
  end
end