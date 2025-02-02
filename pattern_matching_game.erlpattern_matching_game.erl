-module(pattern_matching_game).
-export([start/0]).

% Entry point to start the game
start() ->
    io:format("Welcome to the Pattern Matching Game!~n"),
    io:format("There are multiple patterns. Can you guess them all?~n"),
    io:format("You will get 3 attempts per level to guess correctly.~n"),
    io:format("Let's begin!~n"),
    play_game(1, 0).

% Main game loop
play_game(Level, Score) when Level =< 5 ->
    io:format("Level ~p: Guess the pattern.~n", [Level]),
    Pattern = generate_pattern(Level),
    io:format("The pattern is: ~p~n", [Pattern]),
    io:format("You have 3 attempts. Enter your guess (a list of 3 elements): "),
    Guess = get_guess(),
    case check_guess(Guess, Pattern) of
        correct -> 
            io:format("Correct! You guessed the pattern.~n"),
            NewScore = Score + 10,
            io:format("Your current score: ~p~n", [NewScore]),
            play_game(Level + 1, NewScore);
        wrong -> 
            io:format("Wrong guess. You have 2 attempts remaining.~n"),
            play_game(Level, Score)
    end;
play_game(_, Score) ->
    io:format("Game Over! Your final score is: ~p~n", [Score]),
    io:format("Thank you for playing!~n").

% Generate pattern based on the level
generate_pattern(1) -> [a, b, c];
generate_pattern(2) -> [d, e, f];
generate_pattern(3) -> [g, h, i];
generate_pattern(4) -> [x, y, z];
generate_pattern(5) -> [j, k, l].

% Get the player's guess
get_guess() ->
    {ok, Guess} = io:fread("", "['a'..'z'],[\\s]*"),
    validate_guess(list_to_tuple(Guess)).

% Validate guess length and content
validate_guess(Guess) when length(Guess) == 3, is_valid_pattern(Guess) ->
    Guess;
validate_guess(_) ->
    io:format("Invalid input. Please enter a list of exactly 3 elements from [a, b, c, d, e, f, g, h, i, j, k, l, x, y, z].~n"),
    get_guess().

% Check if guess is valid (only contains valid characters)
is_valid_pattern([A, B, C]) when A >= a, A =< z, B >= a, B =< z, C >= a, C =< z -> true;
is_valid_pattern(_) -> false.

% Compare the player's guess with the correct pattern
check_guess(Guess, Pattern) when Guess == Pattern -> correct;
check_guess(_, _) -> wrong.

% Give hint if the player struggles
give_hint(Pattern) ->
    io:format("Hint: The first letter of the pattern is ~p~n", [hd(Pattern)]).

% Game rules explained using guards for error handling
print_game_rules() ->
    io:format("Game Rules:~n"),
    io:format("1. Guess the pattern correctly to win points.~n"),
    io:format("2. There are 5 levels with different patterns.~n"),
    io:format("3. Each correct guess earns 10 points.~n"),
    io:format("4. You can make 3 attempts per level.~n"),
    io:format("5. If your guess is incorrect, you can try again, but you will lose attempts.~n").

% Display score at each level
display_score(Score) ->
    io:format("Your score is: ~p~n", [Score]).

% Check if the user wants to continue or quit
check_continue() ->
    io:format("Do you want to continue? (yes/no): "),
    {ok, Response} = io:fread("", "~s"),
    case string:trim(Response) of
        "yes" -> start();
        "no" -> io:format("Thanks for playing! Goodbye.~n");
        _ -> io:format("Invalid response. Please enter 'yes' or 'no'.~n"),
             check_continue()
    end.

% Display a countdown before starting the game
display_countdown() ->
    io:format("Get ready! Starting in 3 seconds...~n"),
    timer:sleep(1000),
    io:format("2...~n"),
    timer:sleep(1000),
    io:format("1...~n"),
    timer:sleep(1000),
    io:format("Go!~n").
