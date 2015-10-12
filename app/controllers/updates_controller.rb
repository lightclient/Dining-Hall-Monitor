class UpdatesController < ApplicationController
  def new
    @update = Update.new

    @bruin_cafe   = find_current_load("BruinCafe")
    @bruin_plate  = find_current_load("BruinPlate")
    @cafe_1919    = find_current_load("Cafe1919")
    @covell       = find_current_load("Covell")
    @de_neve      = find_current_load("DeNeve")
    @feast        = find_current_load("FEAST")
    @rendezvous   = find_current_load("Rendezvous")

  end

  def create
    @update = Update.new(hall_name: params[:update][:hall_name], load: params[:commit])
    if @update.save
      cookies[:updated] = { :value => "Y", :expires => 4.hours.from_now }
      redirect_to root_path
    end
  end

  def find_current_load(hall_name)
    updates = Update.where(hall_name: hall_name, created_at: 4.hours.ago..0.seconds.ago).sort_by(&:created_at).reverse

    if updates.size != 0

      avg = 0

      for u in updates
        if u.load == "Low"
          avg += 300 - ((Time.now - u.created_at) / 10)
        end

        if u.load == "Moderate"
          avg += 600 - ((Time.now - u.created_at) / 10)
        end

        if u.load == "Heavy"
          avg += 1000 - ((Time.now - u.created_at) / 10)
        end
      end

      avg = avg / updates.size

      case avg
        when 0..399
          return "low"
        when 400..700
          return "moderate"
        when 701..1000
          return "heavy"
      end

    return "unknown"
  end
end
