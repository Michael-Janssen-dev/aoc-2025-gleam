import z3

def part1(indicators: str, buttons, _):
    presses = [z3.Bool(f"B{i}") for i in range(len(buttons))]
    s = z3.Optimize()
    
    for i, ind in enumerate(indicators):
        affected_by = [presses[j] for j, b in enumerate(buttons) if i in b]
        b = False
        for a in affected_by:
            b = z3.Xor(b, a)
        if ind == ".":
            s.add(b == False)
        else:
            s.add(b == True)
    
    s.minimize(sum(presses))
    
    assert s.check() == z3.sat
    
    result = 0
    model = s.model()
    for m in model:
        if model[m]: #type: ignore
            result += 1
    return result
      
def part2(_, buttons, joltage):
    presses = [z3.Int(f"B{i}") for i in range(len(buttons))]
    s = z3.Optimize()
    
    for p in presses:
        s.add(p >= 0)
    
    for i, jol in enumerate(joltage):
        affected_by = [presses[j] for j, b in enumerate(buttons) if i in b]
        s.add(sum(affected_by) == jol)
    
    s.minimize(sum(presses))
    
    assert s.check() == z3.sat
    
    result = 0
    model = s.model()
    for m in model:
        result += model[m].as_long()
    return result
    
    
    
    

with open("input/2025/10.txt") as f:
    lines = [x.strip().split(" ") for x in f.readlines()]

parsed = []
for line in lines:
    indicators, buttons, joltage = line[0], line[1:-1], line[-1]
    indicators = indicators[1:-1]
    buttons = [list(map(int, b[1:-1].split(","))) for b in buttons]
    joltage = list(map(int, joltage[1:-1].split(",")))
    parsed.append((indicators, buttons, joltage))
    

print(sum(map(lambda x: part1(*x), parsed)))
print(sum(map(lambda x: part2(*x), parsed)))