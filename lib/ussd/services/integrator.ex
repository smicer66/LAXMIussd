defmodule Ussd.Integrator do
  alias Ussd.HelperService
  alias Ussd.Ussd.Configs

  def query_integrator(map) do
    # %{body: "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><reply sessionState=\"3\">Laxmi Loans\nComing Soon.</reply>"}
    cond do
      map[:source] === "MTNZ" ->
        uri = HelperService.build_params(map, HelperService.get_menu_option(map, "3"))
        endpoint = Configs.find_by(name: "Endpoint")

        case HTTPoison.get(endpoint.value <> uri) do
          {:error, %HTTPoison.Error{id: nil, reason: _reason}} ->
            %{body: "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><reply sessionState=\"3\">An error occured. Please try again Later.</reply>"}

          {:ok, struct} ->
            struct
          end

      map[:source] === "AIRTELZM" ->
        uri = HelperService.build_params(map, HelperService.get_menu_option(map, "4"))
        endpoint = Configs.find_by(name: "Endpoint")

        case HTTPoison.get(endpoint.value <> uri) do
          {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
            IO.inspect reason
            %{body: "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><reply sessionState=\"3\">An error occured. Please try again Later.</reply>"}

          {:ok, struct} ->
            struct
        end

      map[:source] === "ZAMTEL" ->
        uri = HelperService.build_params(map, HelperService.get_menu_option(map, "1"))
        endpoint = Configs.find_by(name: "Endpoint")

        case HTTPoison.get(endpoint.value <> uri) do
          {:error, %HTTPoison.Error{id: nil, reason: _reason}} ->
            %{body: "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><reply sessionState=\"3\">An error occured. Please try again Later.</reply>"}

          {:ok, struct} ->
            struct
          end
    end
  end

  def nested_query_integrator(map) do
    map
  end

end
