defmodule UssdWeb.AirtelController do
  use UssdWeb, :controller
  alias Ussd.HelperService, as: Service
  alias Ussd.{AirtelService, Integrator}

  def airtel_run(conn, %{"MSISDN" => _phone} = params) do
    AirtelService.module_info()
    request =
      Service.log(
        params =
          Map.put(params, "SOURCE", "AIRTELZM")
          |> Map.put("REQUEST", if(params["REQUEST"] == "1", do: "REQUEST", else: "RESPONSE"))
      )#Map.merge
      params =Service.to_atomic(params)
      IO.inspect params, label: "Testing from Airtel"
    case Service.request_type_airtel(params[:request]) do
      "1" ->
        response = Integrator.query_integrator(Map.put(params, :request, "1"))
        Service.update(request, %{response: response.body})
        conn
        |> put_resp_header("Freeflow", Service.translate_request_type("1"))
        |> text(Service.raw_text_response(response.body))

      "2" ->
        if String.trim(params[:ussd_body]) != "" do

          if Service.get_option(params) != "LG" && Service.get_option(params) != "FG" do
            cond do
              Service.get_menu_option(params,"4") == "1" ->
                response = Integrator.query_integrator(Map.put(params, :request, "2"))

                Service.update(request, %{response: response.body})

                Service.create_session(params,"LG")

                conn
                |> put_resp_header("Freeflow", Service.translate_request_type("2"))
                |> text(Service.raw_text_response(response.body))

              Service.get_menu_option(params, "4") == "2" ->
                response = Integrator.query_integrator(Map.put(params, :request, "2"))

                Service.update(request, %{response: response.body})

                Service.create_session(params,"FG")

                conn
                |> put_resp_header("Freeflow", Service.translate_request_type("2"))
                |> text(Service.raw_text_response(response.body))

              true ->
                response = Integrator.query_integrator(Map.put(params, :request, "2"))

                Service.update(request, %{response: response.body})

                conn
                |> put_resp_header("Freeflow", Service.translate_request_type("2"))
                |> text(Service.raw_text_response(response.body))
            end
          else

          end

        else
          conn
          |> put_resp_header("Freeflow", "FB")
          |> text("Oops, We could not understand Your request.")
        end
    end
  end

  def airtel_run(conn,_) do
    conn
      |> put_resp_header("Freeflow", "FB")
      |> text("Oops, We could not understand Your request.")
  end
end
