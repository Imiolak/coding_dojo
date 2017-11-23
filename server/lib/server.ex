defmodule Server do
  use Application

  def start(_type, _args) do

    path_list =  [ 
      {"/api/solve", SolverHandler, []}
    ]
    routes = [{:_, path_list}]
    dispatch_config = :cowboy_router.compile(routes)
    env = [dispatch: dispatch_config]    

  :cowboy.start_http(
    :http,
    100,
    [port: 8089],
    [env: env]
  )

  end
end
