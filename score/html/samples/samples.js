function initializePage()
{
  var now = new Date();
  var datestring = now.getMonthName() + " " + now.getDate() + ", " + now.getFullYear();
  document.getElementById("datetime").innerHTML = datestring; // Insert date into HTML
  showScoreCards();
}

function checkInPlay()
{
  $("#inHand").toggleClass("is-hidden");     // Hide in-hand
  $("#inHandLink").toggleClass("is-hidden"); // Hide quick link
  showScoreCards();

  var inPlay = document.getElementById("inPlay"); // Set button text
  if( inPlay === null || typeof(inPlay) === "undefined") return;
  var inHand = document.getElementById("inHand");
  if(inHand.classList.contains("is-hidden")) { inPlay.innerHTML = "Show hand"; } else { inPlay.innerHTML = "Hide hand"; }
}

function showScoreCards()
{
  var scoreCards = document.getElementById("scoreCards");
  var scoreCardLink = document.getElementById("scoreCardsLink");
  if(round === 1) // Hide score cards
  {
     if(!scoreCards.classList.contains("is-hidden")) { scoreCards.classList.add("is-hidden"); }
     if(!scoreCardLink.classList.contains("is-hidden")) { scoreCardLink.classList.add("is-hidden"); }
  }
  else // Show score cards
  {
     if(scoreCards.classList.contains("is-hidden")) { scoreCards.classList.remove("is-hidden"); }
     if(scoreCardLink.classList.contains("is-hidden")) { scoreCardLink.classList.remove("is-hidden"); }
  }
}

// Make Date provide month full names
Date.prototype.getMonthName = function() 
{
  var month_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  return month_names[this.getMonth()];
}
