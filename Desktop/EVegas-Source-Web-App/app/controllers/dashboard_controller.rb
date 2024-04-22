class DashboardController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user

  def index
    @booking_car = Reservation.includes(:customer => []).joins(:customer => []).order("reservations.pickup_at desc").limit(8).offset(0)
    @booking_mc = MachineReservation.includes(:customer => []).joins(:customer => []).order("machine_reservations.started_at desc").limit(8).offset(0)
    @spas = Spa.includes(:customer => []).joins(:customer => []).order("spas.date_pick desc").limit(8).offset(0)
    @accommodations = Accommodation.includes(:customer => []).joins(:customer => []).order("accommodations.date_pick desc").limit(8).offset(0)
    @officers = Officer.all.order("online desc")
  end
end
