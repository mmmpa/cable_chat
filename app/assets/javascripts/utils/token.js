export default function token() {
  try {
    return document.getElementsByName('csrf-token')[0].getAttribute('content');
  } catch (e) {
    return '';
  }
}
