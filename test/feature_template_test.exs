Code.require_file("test_helper.exs", __DIR__)

defmodule Cabbage.FeatureTestTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "can use custom template" do
    defmodule CustomTemplate do
      use ExUnit.CaseTemplate

      using do
        quote do
          setup_all do
            {:ok, %{case_template: unquote(__MODULE__)}}
          end
        end
      end
    end

    defmodule FeatureTimeoutTest do
      use Cabbage.Feature, file: "simple.feature", template: CustomTemplate

      defgiven ~r/^I provide Given$/, _vars, _state do
        # Your implementation here
      end

      defgiven ~r/^I provide And$/, _vars, _state do
        # Your implementation here
      end

      defwhen ~r/^I provide When$/, _vars, _state do
        # Your implementation here
      end

      defthen ~r/^I provide Then$/, _vars, state do
        assert state.case_template == CustomTemplate
      end
    end

    ExUnit.Server.modules_loaded()
    capture_io(fn -> assert ExUnit.run() == %{failures: 0, skipped: 0, total: 1, excluded: 0} end)
  end
end
