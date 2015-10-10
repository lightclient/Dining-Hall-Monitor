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
    @update = Update.new(update_params)
    if @update.save
      redirect_to root_path
    end
  end

  def update_params
    params.require(:update).permit(:hall_name, :load)
  end

  def find_current_load(hall_name)
    updates = Update.where(hall_name: hall_name, created_at: 1.hour.ago..1.second.ago)
    updates_12 = Update.where(hall_name: hall_name, created_at: 12.hours.ago..1.second.ago)

    if updates.size != 0

      avg = 0

      for u in updates
        if u.load == "Low"
          avg += 1
        end

        if u.load == "Moderate"
          avg += 2
        end

        if u.load == "Heavy"
          avg += 3
        end
      end

      avg = avg / updates.size

      case avg
        when 1
          return "low"
        when 2
          return "moderate"
        when 3
          return "heavy"
      end

      return avg

    elsif updates_12.size != 0

      avg = 0

      for u in updates
        if u.load == "Low"
          avg += 1
        end

        if u.load == "Moderate"
          avg += 2
        end

        if u.load == "Heavy"
          avg += 3
        end
      end

      avg = avg / updates.size

      case avg
        when 1
          return "low"
        when 2
          return "moderate"
        when 3
          return "heavy"
      end
    end

    return "noinfo"
  end
end
