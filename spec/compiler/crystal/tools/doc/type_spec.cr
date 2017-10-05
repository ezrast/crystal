require "../../../../spec_helper"

class TypeStub < Crystal::Type
  def to_s_with_options(io)
  end

  def to_s_with_options(io, skip_union_parens : Bool = false, generic_args : Bool = true, codegen = false)
  end
end

def test_node_to_html(node, expectation)
  program = Program.new

  doc_type = Crystal::Doc::Type.new(
    Crystal::Doc::Generator.new(
      program,
      [] of String
    ),
    TypeStub.new(program)
  )
  html = String.build{ |io| doc_type.node_to_html(node, io, links = false) }
  html.should eq expectation
end

describe Crystal::Doc::Type do
  it "renders nilable types to html" do
    test_node_to_html(ProcNotation.new([Path.new("String")] of Crystal::ASTNode, Path.new("String")),
      "String -> String")
    test_node_to_html(
      ProcNotation.new(
        ([Path.new("String")] of Crystal::ASTNode),
        Crystal::Union.new([
          Path.new("String"),
          Path.new("Nil")
        ] of Crystal::ASTNode)
      ),
      "String -> String?")
    test_node_to_html(
      Crystal::Union.new([
        ProcNotation.new(
          [Path.new("String")] of Crystal::ASTNode,
          Path.new("String")
        ),
        Path.new("Nil")] of Crystal::ASTNode),
      "(String -> String)?")
  end
end
