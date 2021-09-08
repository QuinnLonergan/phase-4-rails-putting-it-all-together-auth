class RecipesController < ApplicationController
    before_action :authorize, only: [:index, :create]
    wrap_parameters format: []
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_response

    def index
        recipe = Recipe.all
        render json: recipe
    end

    def create
        user = User.find(session[:user_id])
        recipe = user.recipes.create!(recipe_params)
        render json: recipe, include: :user, status: :created
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def authorize
        return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end

    def render_invalid_response(e)
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end
end
