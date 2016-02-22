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

# Plz don't make fun of me for my super inefficient code
# startup + yearly should be in hours, so divide by value of time in $/hr first.
def best_start(startup, yearly, decay_rr, decay, hazard_rr, hazard)
  startup /= 8765.8 # hours in a year
  yearly /= 8765.8
  best_savings = 0.0
  best_age = 1000
  for age in 0..100
    years_with = years_left(decay_rr * decay, hazard_rr * hazard * (decay ** age))
    years_without = years_left(decay, hazard * (decay ** age))
    gain = years_with * (1 - yearly) - years_without - startup
    if gain > best_savings
      best_savings = gain
      best_age = age
    end
  end
  return [best_savings, best_age]
end

def threshold(startup, yearly, decay_rr, decay, hazard_rr, hazard)
  startup /= 8765.8 # hours in a year
  yearly /= 8765.8
  best_ratio = 0.0
  best_age = 1000
  for age in 0..100
    years_with = years_left(decay_rr * decay, hazard_rr * hazard * (decay ** age))
    years_without = years_left(decay, hazard * (decay ** age))
    ratio = (years_with - years_without) / (years_with * yearly + startup)
    if ratio > best_ratio
      best_ratio = ratio
      best_age = age
    end
  end
  return [1.0 / best_ratio, best_age]
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

############### Alter this!
timeValue = 60.0

# from http://circ.ahajournals.org/content/109/22/2705.full
puts ""
p "Fish:"
ihd_death_rate = 3087.4
total_death_rate = 14422.2
rr_per_20_gram_over_day = 0.07

fish_rr = 1.0 - (ihd_death_rate / total_death_rate * rr_per_20_gram_over_day / 20) # Benefits are a bit nonlinear, but we're calculating just for 1 g/day of fish.
p "1 g/day of fish has rr of " + fish_rr.to_s
############### Alter this!
fish_cost = 17.99 / 453.6 * 365.2 # Some fish I found at the market. Cost / g/lb * day/yr.
p "1 g/day of fish costs you $" + fish_cost.to_s + " per year"
p "1 g/day of fish earns you " + years_gained(0, 1.0, decay, fish_rr, hazard).to_s + " years of life."
#  return years_left(decay_rr * decay, hazard_rr * hazard * (decay ** age)) \
 #   - years_left(decay, hazard * (decay ** age))
p best_start(0.0, fish_cost / timeValue, 1.0, decay, fish_rr, hazard)
p threshold(0.0, fish_cost , 1.0, decay, fish_rr, hazard)

# Results
# "1 g/day of fish has RR of 0.9992507453786523"
# "1 g/day of fish costs you $14.48401234567901 per year"
# "1 g/day of fish earns you 0.0070281073951150574 years of life."
# [optimal gain, start age]
# [0.005692665013903309, 41]
# [threshold ratio, .]
# [2.536722856331994, 100]


# from http://ajcn.nutrition.org/content/70/3/500s.full
# especially http://ajcn.nutrition.org/content/70/3/500s/T3.expansion.html
puts ""
p "Nuts:"

nut_2_times_rr = 0.88 # Really, 1-4. I'll use 2.5



nut_5_times_rr = 0.67 # Really, >= 5. I'll use 5.5


# Can we find evidence of altered decay rates? Best possible data would likely be an intervention (positive or negative) used for >20 years, followed by non-intervention for >20 years. Trend lines during the intervention and hazard rr after can distinguish some heterogeneous population effect from a decay effect.
# Trend line calculations for smoking: https://docs.google.com/spreadsheets/d/1mquZAD6hxZAX3hG6Tf3V9LadZyfNYyHFK6u0RhtkzO0/edit#gid=0
# Somebody's calculated trend lines for smoking: https://ije.oxfordjournals.org/content/27/5/885.full.pdf
# It's difficult to interpret raw smoking rr's and trend lines: http://www.pnas.org/content/106/2/393.full
