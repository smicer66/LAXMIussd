defmodule Ussd.HelperService do
  import SweetXml
  # import AtomicMap

  alias Ussd.Ussd.Logs
  alias Ussd.Ussd.Session

  @max_life 60

  def raw_text_response(param) do
    if xpath(param, ~x"//reply/text()") do
      xpath(param, ~x"//reply/text()"s)
    else
      "An error occured. Please try again Later."
    end
  end

  def request_type_airtel(type) do
    cond do
      type === "REQUEST" ->
        "1"
      type === "RESPONSE" ->
        "2"
      type ->
        "0"
    end
  end

  def request_type_mtn(type) do
    cond do
      type === "1" ->
        "1"
      type === "0" ->
        "2"
      type ->
        "1"
    end
  end

  def build_zamtel_params(params,response) do
    "?TransId="<>params[:trans_id]<>"&Pid="<>params[:pid]<>
    "&RequestType=2&MSISDN="<>params[:msisdn]<>
    "&AppId="<>params[:app_id]<>"&USSDString="<>to_string(raw_text_response(response))
  end

  def translate_request_type(type) do
    cond do
      type === "0" ->
        "FC"
      type === "1" ->
        "FC"
      type === "2" ->
        "FC"
      true ->
        "FB"
    end
  end

  def create_session(map, option) do
    case Session.create!(%{
           user_mobile: map[:msisdn],
           session_data: map[:msisdn] <> inspect(Enum.random(1_00000..9_00000)),
           source: map[:source]
         }) do
      {:error, _reason} ->
        IO.puts("Failed to add Logs")
        false

      struct ->
        update_session(struct, %{options: option})
        true
    end
      #     $this->garbageCollection($mobile);
  end

  def update_session(struct, params) do
    case(Session.update(struct, params)) do
      {:ok, _update} ->
        IO.puts("Successfully updated Session")

      {:error, _reason} ->
        IO.puts("Failed to update Session")
    end
  end

  def get_menu_option(map, trick) do
    IO.inspect map
    case trick do
      "1" ->
        cond do
          Enum.count(String.split(map[:ussd_string],"*")) <=2->
            ""
          true->
            String.split(map[:ussd_string],"*")|>List.last()
        end

      "2" ->
        IO.puts("This is trick 2")

      "3" ->
        map[:input]

      "4" ->
        map[:ussd_body]
    end
  end

  def get_option(map) do
    case Session.where([user_mobile: map[:msisdn], source: map[:source]], limit: 1, order_by: [desc: :id]) do
      [] ->
        false
      list ->
        Enum.map(list, fn x->
          x.options
        end)
    end
  end

  def garbage_collector(mobile) do
    case Session.where([user_mobile: mobile], order_by: [desc: :id]) do
      [] ->
        false

      list ->
        Enum.each(list, fn x ->
          case validate_session_date(x.inserted_at) do
            nil ->
              IO.puts("ACTIVE SESSION")

            false ->
              nil

            true ->
              Session.delete_where(
                user_mobile: x.user_mobile,
                inserted_at: x.inserted_at,
                source: x.source
              )
          end
        end)
    end
  end

  def validate_session_date(date) do
    today = NaiveDateTime.utc_now()
    session_date = NaiveDateTime.to_date(date)

    if session_date == today |> NaiveDateTime.to_date() do
      if abs(NaiveDateTime.diff(date, today, :second)) >= @max_life do
        true
      end
    else
      false
    end
  end


  def build_params(map, code) do
    IO.inspect map
    IO.inspect code
    case map[:source] do
      "MTNZ"->
        "?session_id=" <>
        URI.encode(map[:sessionid]) <>
        "&mobile_number=" <> URI.encode(map[:msisdn]) <> "&text=" <> URI.encode(code)

      "AIRTELZM"->
        "?MOBILE_NUMBER=" <>
        URI.encode(map[:msisdn]) <>
        "&REQUEST_TYPE=" <> URI.encode(map[:request]) <> "&USSD_BODY=" <> URI.encode(code)
      "ZAMTEL"->
        "?MOBILE_NUMBER=" <>
        URI.encode(map[:msisdn]) <>
        "&REQUEST_TYPE=" <> URI.encode(map[:request]) <> "&USSD_BODY=" <> URI.encode(code)
    end

  end

  def log(json_string) do
    case Logs.create!(%{request: Poison.encode!(json_string), source: json_string["SOURCE"]}) do
      {:error, _reason} ->
        IO.puts("Failed to add Logs")

      struct ->
        struct
    end
  end

  def update(struct, params) do
    case(Logs.update(struct, params)) do
      {:ok, _update} ->
        IO.puts("Successfully updated Logs")

      {:error, _reason} ->
        IO.puts("Failed to update Logs")
    end
  end

  def backup do
  end

  def is_logged_out(response) do
    if xpath(response, ~x"//reply/@sessionState") do
      cond do
        xpath(response, ~x"//reply/@sessionState") == '3'->
          true
        true->
          false
      end
    else
      "An error occured. Please try again Later."
    end
  end

  def to_atomic(params) do
    AtomicMap.convert(params, %{safe: false})
  end

end
