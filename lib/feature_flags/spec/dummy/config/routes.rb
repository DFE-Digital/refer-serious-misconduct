Rails.application.routes.draw do
  mount FeatureFlags::Engine, at: "/feature_flags", as: "feature_flags"
end
