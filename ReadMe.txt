Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
 *
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
 *
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

F*Scoreboard
Authors: Sean McCracken (@Seantron) & Jesse Freeman (@CodeBum)

F*Scoreboard is a simple class to help maintain persistent local scoreboard in your Flash games. The FScoreboard class
wraps a SharedObject and allows you to save and retrieve score objects from it. This allows you to manage scores without
the need of connecting to a database or 3d party api. This is especially helpful when it comes to Mobile Flash games.

Here are some examples of how to use the class:

:: Create A New Scoreboard ::

scoreBoard = new FScoreboard("TestScoreboard", 10);


:: Add Some Default Scores ::

scoreBoard = new FScoreboard("TestScoreboard", 10);

if(scoreBoard.total == 0)
{
    var defaultScores:Array = [
                {playerName:"PlayerA", score: 300},
                {playerName:"PlayerB", score: 200},
                {playerName:"PlayerC", score: 100},
                {playerName:"PlayerD", score: 10}];

    scoreBoard.scores = defaultScores;

}

:: Add New Score ::

scoreBoard.addScore({score:100});


:: Display Scores ::

var total:int = scoreBoard.length;
var i:int;

for( i = 0; i < total; i ++)
{
    trace(scoreboard.getScore(i).score);
}
