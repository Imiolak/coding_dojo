defmodule SolverHandler do
    def init(request, options) do 
        headers = [{"content-type", "application/json"}]
        body = "{ \"result\": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }"

        request = :cowboy_req.reply(200, headers, body, request)
        {:ok, request, options}
    end
end