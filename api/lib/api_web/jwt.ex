defmodule Api.JWTHandle do

  def createJWT(params) do
    JsonWebToken.sign(params, %{alg: "none"})
  end

  def decodeJWT(jwt_token) do
    JsonWebToken.verify(jwt_token, %{alg: "none"})
  end

end
