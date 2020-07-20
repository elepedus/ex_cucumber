defmodule ExCucumber.Exceptions.Messages.Common do
  @moduledoc false
  alias ExCucumber.Gherkin.Keywords, as: GherkinKeywords
  alias ExCucumber.Gherkin.Traverser.Ctx

  def render(:code_block, str) when is_binary(str) do
    """
    ```elixir
    #{str}
    ```
    """
  end

  def render(:macro_usage, %Ctx{} = ctx, cucumber_expression) do
    r =
      if macro_style = ctx.extra[:macro_style] do
        """
        #{GherkinKeywords.macro_name(ctx, macro_style)} "#{cucumber_expression}", arg do
        end
        """
      else
        """
        #{GherkinKeywords.macro_name(ctx)} "#{cucumber_expression}", arg do
        end
        """
      end

    render(:code_block, r)
  end

  def render(:config_option, key, value) do
    r = """
    config :ex_cucumber,
      #{key}: #{inspect(value, pretty: true)}
    """

    render(:code_block, r)
  end

  def render(:feature_file, %Ctx{} = ctx) do
    """
    `#{Exception.format_file_line(ctx.feature_file, ctx.location.line, ctx.location.column)}`
    """
  end

  def render(:module_file, %Ctx{} = ctx),
    do: render(:module_file, ctx.module_file, ctx.location.line, ctx.location.column)

  def render(:module_file, module_file, line, column) do
    """
    `#{Exception.format_file_line(module_file, line, column)}`
    """
  end
end