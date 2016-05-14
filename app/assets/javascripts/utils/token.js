export default function token() {
  return document.getElementsByName('csrf-token')[0].getAttribute('content');
}
