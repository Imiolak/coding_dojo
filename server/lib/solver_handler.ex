defmodule SolverHandler do
    def init(request, options) do

        headers = [{"content-type", "application/json"}, {"access-control-allow-origin", "*"}]

        if :cowboy_req.method(request) != "POST" do
            body = "{ \"fuck you\": \"send a POST!!!\" }"
        else
            {_ok, heights_raw, _req2} = :cowboy_req.body(request)
            {:ok, heights} = Poison.decode(heights_raw)
            {isValid, result} = Solver.solve(heights, 4)
            body = "{ \"isValid\": #{isValid},  \"result\": #{Poison.Encoder.encode(result, [])} }"
        end

        request = :cowboy_req.reply(200, headers, body, request)
        {:ok, request, options}
    end
end
