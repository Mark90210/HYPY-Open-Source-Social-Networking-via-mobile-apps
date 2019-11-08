get '/events' do
  current_events = []
  past_events = []
  begin
    Gallery.all.order({ created_at: :desc }).each.map do |gallery|
      if !params.has_key?('remove_photos')
        gallery.load_count_photos
      end
      gallery.load_count_active_users
      past_events.push gallery
    end
    current_events.push past_events.shift
    status 200
    [
      {
        position: 0,
        title: nil,
        events: current_events
      },
      {
        position: 1,
        title: 'Past Events',
        events: past_events
      }
    ].to_json
  rescue
    status 500
  end  
end

get '/splash' do
  splash_image = AppSetting.find_by(name: 'splash_image')
  spl_image = splash_image.present? ? splash_image.value : nil

  eul_pdf = AppSetting.find_by(name: 'eul')
  eula = eul_pdf.present? ? eul_pdf.value : nil
  
  status 200
  {
    splash_image: spl_image,
    eula: eula
  }.to_json
end