// Make Date provide month full names
Date.prototype.getMonthName = function () {
	var month_names = [
		'January', 'February', 'March', 'April', 'May', 'June',
		'July', 'August', 'September', 'October', 'November', 'December'];
	return month_names[this.getMonth()];
}

function fnWriteLastUpdated() {
	var lastUpd = fnFormatLastUpdated();
	document.write(lastUpd);
}

function fnFormatLastUpdated() {
	var updDate = new Date(document.lastModified);
	var datestring = updDate.getMonthName() + " " + updDate.getDate() + ", " + updDate.getFullYear();
	return datestring;
}
