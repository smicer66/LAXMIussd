defmodule Ussd.Accounts do

    import  Ecto.Query, warn: false
    alias Ussd.Repo
    alias Ussd.Ussd.Users

    def create_user(attrs \\ %{}) do
        %Users{}
        |> Users.changeset(attrs)
        |> Repo.insert()
    end

    # def delete_user(%User{} = user) do
    #     Repo.delete(user)        
    # end
end