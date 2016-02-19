decay = 1.1124
hazard = 1.6443 * 10**-5

def years_left(decay, hazard)
  expected = 0.0
  remaining = 1.0
  while hazard < 1.0
    expected += remaining
    remaining *= (1.0 - hazard)
    hazard *= decay
  end
  
  return expected
end

def years_gained_est(decay_rr, decay, hazard_rr, hazard); - Math.log(hazard_rr) / Math.log(decay); end

def best_age(start, yearly, decay, hazard)
end 

p years_left(decay, hazard)
p years_left(decay, 0.5 * hazard) - years_left(decay, hazard)
p years_gained_est(1.0, decay, 0.5, hazard)

puts "\n"
puts "Fast forward"
hazard *= decay ** 70
p years_left(decay, 0.5 * hazard) - years_left(decay, hazard)
p years_gained_est(1.0, decay, 0.5, hazard)
