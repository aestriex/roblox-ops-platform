// Minimal local-date (no timezone) helper matching the interface expected by
// controllers/ui/date-picker_controller.js (ported from
// https://github.com/airblade/stimulus-datepicker).

const pad = (n) => String(n).padStart(2, "0");

export default class IsoDate {
  constructor(...args) {
    let year, month, day;

    if (args.length >= 3) {
      [year, month, day] = args;
    } else if (args.length === 1 && IsoDate.isValidStr(args[0])) {
      [year, month, day] = args[0].split("-");
    } else {
      const now = new Date();
      year = now.getFullYear();
      month = now.getMonth() + 1;
      day = now.getDate();
    }

    this.yyyy = +year;
    this.mm = pad(+month);
    this.dd = pad(+day);
  }

  toString() {
    return `${this.yyyy}-${this.mm}-${this.dd}`;
  }

  toDate() {
    return new Date(this.yyyy, +this.mm - 1, +this.dd);
  }

  equals(other) {
    return this.toString() === other.toString();
  }

  before(other) {
    return this.toDate().getTime() < other.toDate().getTime();
  }

  after(other) {
    return this.toDate().getTime() > other.toDate().getTime();
  }

  addDays(n) {
    const date = this.toDate();
    date.setDate(date.getDate() + n);
    return new IsoDate(date.getFullYear(), date.getMonth() + 1, date.getDate());
  }

  nextDay() {
    return this.addDays(1);
  }

  previousDay() {
    return this.addDays(-1);
  }

  nextWeek() {
    return this.addDays(7);
  }

  previousWeek() {
    return this.addDays(-7);
  }

  addMonths(n, preserveDayOfMonth = true) {
    const date = this.toDate();
    const day = date.getDate();
    date.setDate(1);
    date.setMonth(date.getMonth() + n);

    if (preserveDayOfMonth) {
      const daysInTarget = IsoDate.daysInMonth(date.getMonth() + 1, date.getFullYear());
      date.setDate(Math.min(day, daysInTarget));
    }

    return new IsoDate(date.getFullYear(), date.getMonth() + 1, date.getDate());
  }

  nextMonth(preserveDayOfMonth = true) {
    return this.addMonths(1, preserveDayOfMonth);
  }

  previousMonth(preserveDayOfMonth = true) {
    return this.addMonths(-1, preserveDayOfMonth);
  }

  nextYear() {
    return this.addMonths(12, true);
  }

  previousYear() {
    return this.addMonths(-12, true);
  }

  setDayOfMonth(day) {
    return new IsoDate(this.yyyy, this.mm, day);
  }

  dayOfWeek(firstDayOfWeek = 1) {
    const jsDay = this.toDate().getDay(); // 0 = Sunday .. 6 = Saturday
    return (jsDay - firstDayOfWeek + 7) % 7;
  }

  firstDayOfWeek(firstDayOfWeek = 1) {
    return this.addDays(-this.dayOfWeek(firstDayOfWeek));
  }

  lastDayOfWeek(firstDayOfWeek = 1) {
    return this.addDays(6 - this.dayOfWeek(firstDayOfWeek));
  }

  isFirstDayOfWeek(firstDayOfWeek = 1) {
    return this.dayOfWeek(firstDayOfWeek) === 0;
  }

  isToday() {
    return this.equals(new IsoDate());
  }

  isWeekend() {
    const day = this.toDate().getDay();
    return day === 0 || day === 6;
  }

  getMonthName() {
    return this.toDate().toLocaleString("default", { month: "long" });
  }

  static daysInMonth(month, year) {
    return new Date(year, month, 0).getDate();
  }

  static isValidDate(year, month, day) {
    if (!year || !month || !day) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > IsoDate.daysInMonth(month, year)) return false;
    return true;
  }

  static isValidStr(str) {
    if (typeof str !== "string" || !/^\d{4}-\d{2}-\d{2}$/.test(str)) return false;
    const [y, m, d] = str.split("-").map((n) => parseInt(n, 10));
    return IsoDate.isValidDate(y, m, d);
  }
}
