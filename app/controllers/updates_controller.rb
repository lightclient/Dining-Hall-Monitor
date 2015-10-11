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
      cookies[:updated] = { :value => "Y", :expires => 1.minute.from_now }
      redirect_to root_path
    end
  end

  def find_current_load(hall_name)
    updates = Update.where(hall_name: hall_name, created_at: 1.hour.ago..0.seconds.ago)
    updates_12 = Update.where(hall_name: hall_name, created_at: 12.hours.ago..0.seconds.ago)

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

      avg = avg / updates_12.size

      case avg
        when 1
          return "low"
        when 2
          return "moderate"
        when 3
          return "heavy"
      end
    end

    return "unknown"
  end
end
