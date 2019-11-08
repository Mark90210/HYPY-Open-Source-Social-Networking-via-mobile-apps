module FindOrCreate

  def find_or_create params
    objects = self.where params

    return objects.first if objects.length > 0

    return create params
  end

end