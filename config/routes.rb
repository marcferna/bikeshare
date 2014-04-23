Bikeshare::Application.routes.draw do

  controller :visualizations do
    get 'chord_data/(:city)' => :chord_data
    get 'heat_map_data/(:city)' => :heat_map_data
    get 'subscriptors/(:city)' => :subscriptors
    get 'time_of_day/(:city)' => :time_of_day
    get 'rainy_days/(:city)' => :rainy_days

  end

  get "/(:city)" => "home#index"
  post "/(:city)" => "home#index"
end
