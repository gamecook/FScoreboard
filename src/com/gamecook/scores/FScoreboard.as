/*
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * Authors: Sean McCracken (@Seantron) & Jesse Freeman (@CodeBum)
 *
 */

package com.gamecook.scores
{
    import flash.net.SharedObject;

    public class FScoreboard
    {

        private const ERROR_MESSAGE_NO_SCORE_PROP:String = "Supplied object does not have a score property.";
        protected var so:SharedObject;
        protected var _scores:Array = [];
        protected var id:String;
        protected var maxScores:int;

        /**
         * This is a simple proxy to wrap a SharedObject which stores and array of score objects.
         * Simply create a new instance of the Scoreboard and it will automatically create
         * or load the SharedObject associated with the supplied ID.
         *
         * @param id a unique ID used to store and retrieve the Scoreboard shared Object.
         * @param maxScores this is the maximum number of scores you want to keep track of. By
         *        default it is set to -1 which means it will not truncate the scores.

         */
        public function FScoreboard(id:String, maxScores:int = -1)
        {
            this.maxScores = maxScores <= 0 ? -1 : maxScores;
            this.id = id;
            init();
        }

        /**
         * Add a Score object to the Scoreboard. Your object can have any properties but it should
         * have a score property at the very least. If the supplied object does not have a score
         * property it will throw an error.
         *
         * @param value Object with a score property on it.
         */
        public function addScore(value:Object):void
        {
            if (!value.hasOwnProperty("score"))
                throw new Error(ERROR_MESSAGE_NO_SCORE_PROP);

            _scores.push(value);

            _scores.sort(sortOnValue);

            saveToSharedObject((maxScores > -1) ? _scores.slice(0, maxScores) : _scores);

            loadSharedObject();

        }

        /**
         * Returns a copy of the scores array.
         *
         * @return a copy of the scores array. This may not be the same values stored in the SharedObject.
         */
        public function get scores():Array
        {
            return _scores.slice();
        }

        /**
         * scores allows you to pass in an array of scores which can be used to populate the
         * Scoreboard. If this is not supplied the default value (assuming you have
         * never instantiated the SharedObject) will be an empty array. Use this when you
         * want to populate your game with a set number of high scores the first time it
         * is ever loaded up. An ideal use case would be to create a new instance of the
         * Scoreboard then check to see if it's total is 0. If it is, pass in a set of
         * default values.
         *
         * @param value an array of score objects. At the min, the score object should have
         *        a property for score.
         */
        public function set scores(value:Array):void
        {
            validateScoreObjects(value);

            saveToSharedObject(value);
            loadSharedObject();
        }

        /**
         *
         * Clears the values from the SharedObject's scores array.
         *
         */
        public function clearScoreboard():void
        {
            so = SharedObject.getLocal(id);
            so.data.localScoreboard.length = _scores.length = 0
        }

        /**
         * Makes sure you can actually submit a score before you try to do it. Use this
         * to see if the score is worth saving.
         *
         * @param value score value
         * @return returns true if it would be saved or false if it was not high enough.
         */
        public function canSubmitScore(value:Number):Boolean
        {
            var result:Number;

            var total:int = scores.length;
            var i:int;

            for (i = 0; i < total; i++)
            {
                result = sortOnValue({score:value}, scores[i]);

                if (result <= 0 )
                    return true;
            }


            return false;
        }

        /**
         * Returns the total number of scores in the Scoreboard
         *
         * @return totals scores
         */
        public function get total():int
        {
            return _scores.length;
        }

        /**
         * Allows you to get a score at a particular position in the Scoreboard.
         * @param i the index of the score you are trying to retrieve.
         * @return the score object.
         */
        public function getScore(i:int):Object
        {
            return _scores[i];
        }

        /**
         *
         * @param defaultsScores
         */
        protected function init():void
        {
            so = SharedObject.getLocal(id);

            if (so.data.localScoreboard == null)
            {
                saveToSharedObject(_scores);

            }

            loadSharedObject();
        }

        /**
         *
         */
        private function loadSharedObject():void
        {
            _scores = so.data.localScoreboard.slice();
        }

        /**
         *
         * @param value
         */
        private function saveToSharedObject(value:Array):void
        {
            so.data.localScoreboard = value;
            so.flush();
        }

        /**
         *
         * @param val1
         * @param val2
         * @return
         */
        private function sortOnValue(val1:Object, val2:Object):Number
        {
			return val2.score - val1.score;
        }

        /**
         *
         * @param values
         */
        private function validateScoreObjects(values:Array):void
        {
            for each(var score:Object in values)
            {
                if (!score.hasOwnProperty("score"))
                    throw new Error(ERROR_MESSAGE_NO_SCORE_PROP);
            }
        }

    }
}