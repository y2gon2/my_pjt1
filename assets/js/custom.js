export function toggleButton(btn) {
  btn.classList.toggle('bg-blue-500');
  btn.classList.toggle('bg-gray-600');

  if (btn.innerText === 'READY !!') {
    btn.innerText = 'WAIT  ......  ';
  } else {
    btn.innerText = 'READY !!';
  }
}