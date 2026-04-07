class PagesController < ApplicationController
  def home
    @blog_posts = Rails.cache.fetch("blog_posts", expires_in: 1.hour) do
      NaverBlogService.recent_posts(4)
    end
  end

  def about
  end

  def medical_schools
    @schools = [
      { name: "Semmelweis University", country: "헝가리", duration: "6년", icon: "🏥" },
      { name: "University of Debrecen", country: "헝가리", duration: "6년", icon: "🏫" },
      { name: "Mongolian National University of Medical Sciences", country: "몽골", duration: "6년", icon: "🏛" },
      { name: "St. George's University", country: "그레나다", duration: "MD", icon: "🌴" }
    ]
  end

  def news
  end

  def building
  end

  def reservation
  end

  def reviews
  end

  def directions
  end
end
