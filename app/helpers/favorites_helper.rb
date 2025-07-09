module FavoritesHelper
  def fave_or_unfave_button(movie, favorite)
    if favorite
      button_to '♡ Unheart', movie_favorite_path(movie, favorite), method: :delete, class: 'faves'
    else
      button_to '♥️ Fave', movie_favorites_path(movie), class: 'faves'
    end
  end
end
