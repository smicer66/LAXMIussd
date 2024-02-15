defmodule UssdWeb.ZamtelController do
  use UssdWeb, :controller
  alias Ussd.HelperService, as: Service
  alias Ussd.Integrator


  def zamtel_run(conn, %{"MSISDN" => _phone} = params) do
    logged_request = Service.log(params = Map.put(params, "SOURCE", "ZAMTEL"))
    params = Service.to_atomic(params)
    case Enum.empty?(params) do
      true ->
        conn
        |> put_resp_header("Freeflow", "FB")
        |> text("Oops, We could not understand Your request.")
      false ->
        handle_request(conn,params, logged_request)
    end
  end

  def zamtel_run(conn,_) do
    conn
      |> put_resp_header("Freeflow", "FB")
      |> text("Oops, We could not understand Your request.")
  end

  def handle_request(conn,params,logged_request) do
    case params[:request_type] do
      "1"->
        response = Integrator.query_integrator(Map.put(params, :request, "1"))
        Task.start(fn -> Service.update(logged_request, %{response: response.body}) end)
        conn
        |> put_resp_header("Freeflow", Service.translate_request_type("1"))
        |> text(Service.raw_text_response(response.body))

        # conn
        # |>text(Service.build_zamtel_params(params,response.body))
      "0"->
        if String.trim(params[:input]) != "" do
            case params[:input] do
              "1" ->
                Service.create_session(params,"LG")
                response = Integrator.query_integrator(Map.put(params, :request, "2"))
                Task.start(fn -> Service.update(logged_request, %{response: response.body}) end)
                conn
                |> put_resp_header("Freeflow", Service.translate_request_type(params[:isnewrequest]))
                |> text(Service.raw_text_response(response.body))
              "2"->
                Service.create_session(params,"FG")
                response = Integrator.query_integrator(Map.put(params, :request, "2"))
                Task.start(fn -> Service.update(logged_request, %{response: response.body}) end)
                conn
                |> put_resp_header("Freeflow", Service.translate_request_type(params[:isnewrequest]))
                |> text(Service.raw_text_response(response.body))
              _->
                response = Integrator.query_integrator(Map.put(params, :request, "2"))
                Task.start(fn -> Service.update(logged_request, %{response: response.body}) end)
                conn
                |> put_resp_header("Freeflow", Service.translate_request_type(params[:isnewrequest]))
                |> text(Service.raw_text_response(response.body))
            end
        else
          conn
          |> put_resp_header("Freeflow", "FB")
          |> put_resp_header("charge", "N")
          |> put_resp_header("amount", "0")
          |> text("Oops, Empty USSD provided.")
        end
    end
  end
end
