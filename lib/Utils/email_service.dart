import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  // ─── SMTP Configuration ───────────────────────────────────────────
  // This is YOUR business Gmail that will SEND and RECEIVE the alerts.
  // Steps to get the App Password:
  //  1. Go to https://myaccount.google.com  →  Security
  //  2. Enable 2-Step Verification (if not already on)
  //  3. Go to https://myaccount.google.com/apppasswords
  //  4. Create an App Password (select "Mail" + "Other → Fade Masterz")
  //  5. Paste the 16-character password below (no spaces)
  static const String _businessEmail = 'fademasterz24@gmail.com';
  static const String _appPassword  = 'begxzfasrhwhfows';

  /// Sends a "New Booking" notification email to the business inbox.
  static Future<void> sendBookingNotification({
    required String customerName,
    required List<String> services,
    required String barberName,
    required String date,
    required String time,
    String? shopName,
    String? total,
  }) async {
    try {
      final smtpServer = gmail(_businessEmail, _appPassword);

      final serviceListHtml = services
          .map((s) => '<li style="padding:4px 0;">$s</li>')
          .join();

      final plainServices = services.join(', ');

      final htmlBody = '''
<div style="font-family:'Helvetica Neue',Arial,sans-serif;max-width:600px;margin:auto;padding:24px;background:#1a1a1a;border-radius:12px;">
  <div style="text-align:center;padding-bottom:16px;border-bottom:2px solid #D4A843;">
    <h1 style="color:#D4A843;margin:0;">🔔 New Booking Alert</h1>
    <p style="color:#cccccc;font-size:14px;margin:4px 0 0;">${shopName ?? 'Fade Masterz'}</p>
  </div>

  <div style="padding:20px 0;">
    <p style="color:#ffffff;font-size:16px;">A new appointment has been booked!</p>

    <table style="width:100%;border-collapse:collapse;margin:16px 0;">
      <tr>
        <td style="color:#D4A843;padding:10px 8px;border-bottom:1px solid #333;font-weight:600;width:140px;">Customer</td>
        <td style="color:#ffffff;padding:10px 8px;border-bottom:1px solid #333;">$customerName</td>
      </tr>
      <tr>
        <td style="color:#D4A843;padding:10px 8px;border-bottom:1px solid #333;font-weight:600;">Barber</td>
        <td style="color:#ffffff;padding:10px 8px;border-bottom:1px solid #333;">$barberName</td>
      </tr>
      <tr>
        <td style="color:#D4A843;padding:10px 8px;border-bottom:1px solid #333;font-weight:600;">Date</td>
        <td style="color:#ffffff;padding:10px 8px;border-bottom:1px solid #333;">$date</td>
      </tr>
      <tr>
        <td style="color:#D4A843;padding:10px 8px;border-bottom:1px solid #333;font-weight:600;">Time</td>
        <td style="color:#ffffff;padding:10px 8px;border-bottom:1px solid #333;">$time</td>
      </tr>
      ${total != null ? '''
      <tr>
        <td style="color:#D4A843;padding:10px 8px;border-bottom:1px solid #333;font-weight:600;">Total</td>
        <td style="color:#ffffff;padding:10px 8px;border-bottom:1px solid #333;">$total</td>
      </tr>''' : ''}
    </table>

    <p style="color:#D4A843;font-weight:600;margin-bottom:4px;">Services Requested:</p>
    <ul style="color:#ffffff;font-size:14px;padding-left:20px;margin-top:4px;">
      $serviceListHtml
    </ul>
  </div>

  <div style="text-align:center;padding-top:16px;border-top:2px solid #D4A843;">
    <p style="color:#888;font-size:12px;margin:0;">This is an automated notification from the Fade Masterz app.</p>
  </div>
</div>
''';

      final message = Message()
        ..from = Address(_businessEmail, 'Fade Masterz App')
        ..recipients.add(_businessEmail)              // ← sends TO yourself
        ..subject =
            'New Booking – $customerName | $barberName | $date $time'
        ..text =
            'New booking!\n\nCustomer: $customerName\nBarber: $barberName\n'
            'Date: $date\nTime: $time\nServices: $plainServices'
            '${total != null ? '\nTotal: $total' : ''}'
        ..html = htmlBody;

      final sendReport = await send(message, smtpServer);
      debugPrint('✅ Booking notification email sent: $sendReport');
    } catch (e) {
      // Never block the booking flow if the email fails
      debugPrint('⚠️ Failed to send booking notification email: $e');
    }
  }
}


