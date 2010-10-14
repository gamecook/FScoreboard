/**
 * Created by IntelliJ IDEA.
 * User: jfreeman
 * Date: 10/13/10
 * Time: 8:56 AM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.scores{
    import com.gamecook.scores.FScoreboard;

    import org.flexunit.Assert;

    public class FScoreboardTest {

        private var scoreBoard:FScoreboard;
        private const EMPTY_SCOREBOARD:String = "emptyScoreboard";
        private const EMPTY_SCOREBOARD_2:String = "emptyScoreboard2";

        [Before]
        public function before():void
        {

            var defaultScores:Array = [
                {playerName:"PlayerA", score: 860630},
                {playerName:"PlayerB", score: 1000},
                {playerName:"PlayerC", score: 900},
                {playerName:"PlayerD", score: 800},
                {playerName:"PlayerE", score: 700},
                {playerName:"PlayerF", score: 600},
                {playerName:"PlayerG", score: 500},
                {playerName:"PlayerH", score: 400},
                {playerName:"PlayerI", score: 300},
                {playerName:"PlayerJ", score: 200}
                ];

            scoreBoard = new FScoreboard("UnitTestScoreboard", 10);
            scoreBoard.scores = defaultScores;
        }

        [After]
        public function after():void
        {
            scoreBoard.clearScoreboard();
        }

        [Test]
        public function testCanSubmitScorePass():void
        {
             Assert.assertTrue(scoreBoard.canSubmitScore(250));
        }

        [Test]
        public function testCanSubmitScoreFail():void
        {
            Assert.assertFalse(scoreBoard.canSubmitScore(10));
        }

        [Test]
        public function testCanSubmitScoreSame():void
        {
            Assert.assertTrue(scoreBoard.canSubmitScore(200));
        }

        [Test]
        public function testAddScore():void
        {
            scoreBoard.addScore({playerName: "FooBar", score: 620});

            var score:Object = scoreBoard.scores[5];

            Assert.assertEquals(score.score, 620);
        }

        [Test]
        public function testAddSameScore():void
        {
            scoreBoard.addScore({playerName: "FooBar", score: 400});

            var score:Object = scoreBoard.scores[7];

            Assert.assertEquals(score.score, 400);
            Assert.assertEquals(score.playerName, "FooBar");
        }

        [Test]
        public function testClearScores():void
        {
            scoreBoard.clearScoreboard();
            Assert.assertEquals(scoreBoard.scores.length, 0);
        }

        [Test]
        public function testTotal():void{
            Assert.assertEquals(scoreBoard.total, 10);
        }

        [Test]
        public function testGetScoreAtPosition():void
        {
            Assert.assertEquals(860630, scoreBoard.getScore(0).score);
        }

        [Test]
        public function testMaxScores():void
        {
            scoreBoard.addScore({playerName: "FooBar1", score: 430});
            scoreBoard.addScore({playerName: "FooBar2", score: 550});
            scoreBoard.addScore({playerName: "FooBar3", score: 680});
            Assert.assertEquals(scoreBoard.total, 10);
        }

        [Test]
        public function testDefaultValues():void
        {
            var tempScoreboard:FScoreboard = new FScoreboard(EMPTY_SCOREBOARD);
            Assert.assertEquals(tempScoreboard.total, 0);
            tempScoreboard.clearScoreboard();
        }

        [Test]
        public function testSetDefaultValues():void
        {
            var tempScoreboard:FScoreboard = new FScoreboard(EMPTY_SCOREBOARD_2, -1);
            tempScoreboard.scores = [{name:"PayerA", score: 100},{name:"PayerB", score: 200}, {name:"PayerC", score: 300} ];

            var tempScoreboard2:FScoreboard = new FScoreboard(EMPTY_SCOREBOARD_2);

            Assert.assertEquals(tempScoreboard2.total, 3);

            tempScoreboard2.clearScoreboard();
        }

        [Test(expects="Error")]
        public function testScoreThrowsErrorOnMalformedObject():void
        {
            scoreBoard.addScore({name:"Foobar"});
        }

        [Test(expects="Error")]
        public function testScoresThrowsErrorOnMalformedObject():void
        {
            scoreBoard.scores = [{name:"Foobar"}, {score:100}];
        }
    }
}
