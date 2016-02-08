class GeneralInfo
  def self.kids_id
    @@kids_id = {"Tarjeta de identidad" => "TI", "Registro civil" => "RC", "NUIP" => "NUIP" , "Otro" => "Otro"}
  end
	
	def self.adult_id
		@@adult_id = {"Cedula de Ciudadania" => "CC", "Cedula de extranjeria" => "CE" , "Otro" => "Otro"}
	end
	
end