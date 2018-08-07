# MLB Free Games

Scripts to find today's MLB games, free to watch online!

## Dependencies
+ (See Gemfile)
+ Chrome Web Driver
+ Watir

## Instructions
1. Clone this repository
2. `cd` into the cloned repository
3. Run script
  + Run `ruby script/scores.rb` to pull games from the [MLB Scores](https://www.mlb.com/scores) page
  + Run `ruby script/streams.rb` to pull games from the [MLB Streams](https://www.mlb.com/live-stream-games) page
4. Watch free Baseball!!!

## Notes
+ Tested on MacOS only

## ToDo
+ Omit completed games from report
+ Add free games to publicly accessible calendar (Google, iCal, etc)
+ Differentiate between network broadcasts (MLB, Facebook, etc)
+ Figure out media/stream types (audio, video, etc)
+ Consider making classes of structs (Game, Team, etc)
+ Split MLB classes into client/parser