# These constants come from some study:
# https://www.uva.nl/binaries/content/assets/subsites/amsterdam-school-of-economics-research-institute/uva-econometrics/dp-2013/1303.pdf
# last page
decay = 1.1124
hazard = 1.6443 * 10**-5
# To produce your own constants (and get rr's) fit a line to (year, log(hazard)).

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

def years_gained(age, decay_rr, decay, hazard_rr, hazard)
  return years_left(decay_rr * decay, hazard_rr * hazard * (decay ** age)) \
    - years_left(decay, hazard * (decay ** age))
end

def best_start(startup, yearly, decay_rr, decay, hazard_rr, hazard)
  best_savings = 0
  best_age = 1000
  for age in 0..100
    years_with = years_left(decay_rr * decay, hazard_rr * hazard * (decay ** age))
    years_without = years_left(decay, hazard * (decay ** age))
    gain = years_with * (1 - yearly) - years_without - startup
    if gain < best_savings
      best_savings = gain
      best_age = age
    end
  end
  return [best_savings, best_age]
end

def years_gained_est(decay_rr, decay, hazard_rr, hazard); - Math.log(hazard_rr) / Math.log(decay); end

'
p years_left(decay, hazard)
p years_gained(0, 1.0, decay, 0.5, hazard)
p years_gained_est(1.0, decay, 0.5, hazard)

puts "\n"
p "Fast forward"
p years_gained(70, 1.0, decay, 0.5, hazard)
p years_gained_est(1.0, decay, 0.5, hazard)

for i in 18..104
  p "At age " + i.to_s + " a year of the intervention gets you " \
    + (- years_gained(i, 1.0, decay, 0.5, hazard) + years_gained(i - 1, 1.0, decay, 0.5, hazard)).to_s
end
'

timeValue = 60
puts ""
p "Sunlight:"
