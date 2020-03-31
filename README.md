# cmg_sensor_qualifier
Ingests sensor logs and returns classifications and detects faulty sensors

## Notes on input
The spec for this tool instructs us to expect a newline-delimited string for our entry-point input.
Later in the spec, it also mentions that the log can be of N size.

As a result, I suggest that the input instead be a reference to a I/O object that can be read in chunks by our tool.
Doing so will mitigate the possibility of filling up the system memory, at the expense of processing speed.

## Notes about log format
Currently, the log file defines the constant reference variables on one single line in an indeterminate order.
This is not ideal.

When 365-Widgets wants to test more sensors, they will need to ensure that the order of their logging app matches the order expected by the parser 1-1.

This creates the possibility of veiled malfunction.
If two values were accidentally swapped, or the order of the values was misunderstood by a developer, the evaluator would happily use the wrong values for comparisons, unable to recognize the error.

Relying on positional order for this `reference` line is prone to mistakes, impossible to know without external info, and nearly guarantees future headaches when scaling.

Instead, the logs should contain separate lines for each reference value.
Example:
```
reference temperature 70.0
reference humidity 45.0
reference monoxide 6
```
Which can then be parsed verbatim, mitigating the risk of a developer error causing veiled malfunctions.
Conceptually, an extra check could be implemented to ensure that the values are correct before proceeding (something that is not possible in the current system due to the positional nature of the values).

Minimizing risk of mistakes/bugs is of grave importance when running tests on essential sensors.

Another option would be to have each module output its own log for each testing session.
Among other benefits, this would allow us to leverage threading to speed up the evaluation of the logs.

## Notes about module structure
One of my major goals with this tool was to make it dead simple to add new Sensor Modules without requiring new devs to write extensive business logic for their new sensor.
Turns out, that can get a bit complicated, and may add more complexity than it saves.

I believe that keeping complexity to a minimum is the best way to ensure that this project is both maintainable and extensible, even if it means greater repetition. 
Especially when I can only guess what future sensors may need to check.

As a result, I've been a little more explicit with my checks.
Future developers can expect to write most of their own checks and comparisons within the new module, but may use some of the tools that have been made available in `SensorModule`.

One of my primary goals with the `SensorModule` was to exclude anything module-specific.
I was unable to achieve that goal to the degree I initially hoped for.

As a consequence of my minor failure, the `SensorModule` contains some shared methods are used by only one other sensor module (`Thermometer`)
I struggled greatly with this decision, but I imagine that future sensor tests will make use of those methods, so I ultimately decided to leave them as-is.

I also considered grouping the tests into "types" (for example, Humidity and CO sensors are effectively the same, but with different acceptable thresholds) and creating type-based children of `SensorModule` (`Humidity > ThresholdModule > SensorModule`?) to DRY things up a bit more.
However, because I just can't accurately predict what future sensor tests would look like, this could actually end up being too opinionated, requiring future devs to refactor more than they bargained for.
